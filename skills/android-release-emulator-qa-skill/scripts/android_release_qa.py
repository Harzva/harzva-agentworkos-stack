#!/usr/bin/env python3
"""Android release APK QA helper.

The script is intentionally conservative: it gathers evidence and exits with a
non-zero status only for hard blockers such as missing adb, missing APK, failed
install, or failed launch when launch was requested.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time
import urllib.request
from pathlib import Path
from typing import Any


COMMON_ADB_PATHS = [
    r"C:\Program Files\Netease\MuMuPlayer-12.0\shell\adb.exe",
    r"C:\Program Files\Netease\MuMu Player 12\shell\adb.exe",
    r"C:\Program Files (x86)\Netease\MuMuPlayer-12.0\shell\adb.exe",
]


def run(cmd: list[str], timeout: int = 60, binary: bool = False) -> dict[str, Any]:
    try:
        completed = subprocess.run(
            cmd,
            check=False,
            capture_output=True,
            timeout=timeout,
        )
    except FileNotFoundError as exc:
        return {"cmd": cmd, "returncode": 127, "stdout": "", "stderr": str(exc)}
    except subprocess.TimeoutExpired as exc:
        return {
            "cmd": cmd,
            "returncode": 124,
            "stdout": exc.stdout or b"" if binary else (exc.stdout or ""),
            "stderr": exc.stderr or b"" if binary else (exc.stderr or ""),
        }

    stdout: Any = completed.stdout if binary else completed.stdout.decode("utf-8", "replace")
    stderr: Any = completed.stderr if binary else completed.stderr.decode("utf-8", "replace")
    return {
        "cmd": cmd,
        "returncode": completed.returncode,
        "stdout": stdout,
        "stderr": stderr,
    }


def find_adb(explicit: str | None = None) -> str | None:
    candidates: list[str] = []
    if explicit:
        candidates.append(explicit)
    path_adb = shutil.which("adb")
    if path_adb:
        candidates.append(path_adb)

    for env_name in ["ANDROID_HOME", "ANDROID_SDK_ROOT", "LOCALAPPDATA"]:
        value = os.environ.get(env_name)
        if not value:
            continue
        base = Path(value)
        if env_name == "LOCALAPPDATA":
            candidates.append(str(base / "Android" / "Sdk" / "platform-tools" / "adb.exe"))
        else:
            candidates.append(str(base / "platform-tools" / "adb.exe"))
            candidates.append(str(base / "platform-tools" / "adb"))

    candidates.extend(COMMON_ADB_PATHS)

    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return candidate
    return None


def parse_devices(output: str) -> list[dict[str, str]]:
    devices: list[dict[str, str]] = []
    for line in output.splitlines()[1:]:
        line = line.strip()
        if not line:
            continue
        parts = line.split()
        if len(parts) < 2:
            continue
        devices.append({"serial": parts[0], "state": parts[1], "detail": " ".join(parts[2:])})
    return devices


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def write_json(path: Path, data: Any) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def github_release_assets(spec: str) -> dict[str, Any]:
    if "@" not in spec or "/" not in spec.split("@", 1)[0]:
        return {"error": "Use owner/repo@tag, for example Harzva/GitReleaseMarket@v0.1.9"}
    repo, tag = spec.split("@", 1)
    api = f"https://api.github.com/repos/{repo}/releases/tags/{tag}"
    try:
        with urllib.request.urlopen(api, timeout=30) as response:
            raw = json.loads(response.read().decode("utf-8"))
    except Exception as exc:  # noqa: BLE001 - the caller needs the evidence.
        return {"api": api, "error": str(exc)}

    return {
        "api": api,
        "url": raw.get("html_url"),
        "tag": raw.get("tag_name"),
        "assets": [
            {
                "name": asset.get("name"),
                "size": asset.get("size"),
                "digest": asset.get("digest"),
                "download_url": asset.get("browser_download_url"),
            }
            for asset in raw.get("assets", [])
        ],
    }


def adb_cmd(adb: str, serial: str | None, args: list[str]) -> list[str]:
    cmd = [adb]
    if serial:
        cmd.extend(["-s", serial])
    cmd.extend(args)
    return cmd


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate an Android release APK with adb evidence.")
    parser.add_argument("--apk", help="Path to APK to install and inspect.")
    parser.add_argument("--package", help="Android package name to launch.")
    parser.add_argument("--activity", help="Optional fully qualified activity, used with package/activity launch.")
    parser.add_argument("--adb", help="Explicit adb executable path.")
    parser.add_argument("--serial", help="ADB device serial. Defaults to first online device.")
    parser.add_argument("--connect", action="append", default=[], help="ADB tcp endpoint to connect first, for example 127.0.0.1:7555.")
    parser.add_argument("--github-release", help="GitHub release in owner/repo@tag form.")
    parser.add_argument("--output", default="android-release-qa-output", help="Output evidence directory.")
    parser.add_argument("--log-lines", type=int, default=600, help="Number of logcat lines to capture.")
    parser.add_argument("--no-launch", action="store_true", help="Install and capture device evidence without launching the app.")
    args = parser.parse_args()

    out_dir = Path(args.output)
    out_dir.mkdir(parents=True, exist_ok=True)

    summary: dict[str, Any] = {
        "status": "blocked",
        "started_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "mumu_download": "https://mumu.163.com/360mumu/",
        "output": str(out_dir.resolve()),
    }

    if args.github_release:
        release = github_release_assets(args.github_release)
        write_json(out_dir / "github-release.json", release)
        summary["github_release"] = release

    adb = find_adb(args.adb)
    summary["adb"] = adb
    if not adb:
        summary["error"] = "adb not found. Install Android SDK Platform Tools or MuMu, then rerun."
        write_json(out_dir / "summary.json", summary)
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        return 2

    for endpoint in args.connect:
        result = run([adb, "connect", endpoint], timeout=30)
        write_json(out_dir / f"adb-connect-{endpoint.replace(':', '_')}.json", result)

    devices_result = run([adb, "devices", "-l"], timeout=30)
    write_json(out_dir / "adb-devices.json", devices_result)
    devices = [d for d in parse_devices(devices_result.get("stdout", "")) if d["state"] == "device"]
    summary["devices"] = devices
    if not devices:
        summary["error"] = "No online adb device. Start MuMu or another emulator and rerun."
        write_json(out_dir / "summary.json", summary)
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        return 3

    serial = args.serial or devices[0]["serial"]
    summary["serial"] = serial

    apk_path: Path | None = None
    if args.apk:
        apk_path = Path(args.apk)
        if not apk_path.exists():
            summary["error"] = f"APK not found: {apk_path}"
            write_json(out_dir / "summary.json", summary)
            print(json.dumps(summary, ensure_ascii=False, indent=2))
            return 4
        summary["apk"] = {
            "path": str(apk_path.resolve()),
            "size": apk_path.stat().st_size,
            "sha256": sha256_file(apk_path),
        }
        write_json(out_dir / "apk.json", summary["apk"])
        install_result = run(adb_cmd(adb, serial, ["install", "-r", "-d", str(apk_path)]), timeout=180)
        write_json(out_dir / "install.json", install_result)
        summary["install_returncode"] = install_result["returncode"]
        if install_result["returncode"] != 0:
            summary["status"] = "fail"
            summary["error"] = "APK install failed."
            write_json(out_dir / "summary.json", summary)
            print(json.dumps(summary, ensure_ascii=False, indent=2))
            return 5

    device_props = run(adb_cmd(adb, serial, ["shell", "getprop"]), timeout=30)
    (out_dir / "getprop.txt").write_text(device_props.get("stdout", ""), encoding="utf-8")

    if args.package and not args.no_launch:
        if args.activity:
            component = f"{args.package}/{args.activity}"
            launch_cmd = adb_cmd(adb, serial, ["shell", "am", "start", "-n", component])
        else:
            launch_cmd = adb_cmd(
                adb,
                serial,
                ["shell", "monkey", "-p", args.package, "-c", "android.intent.category.LAUNCHER", "1"],
            )
        launch_result = run(launch_cmd, timeout=45)
        write_json(out_dir / "launch.json", launch_result)
        summary["launch_returncode"] = launch_result["returncode"]
        time.sleep(3)
        if launch_result["returncode"] != 0:
            summary["status"] = "fail"
            summary["error"] = "App launch failed."
            write_json(out_dir / "summary.json", summary)
            print(json.dumps(summary, ensure_ascii=False, indent=2))
            return 6
    elif args.apk and not args.package and not args.no_launch:
        summary["launch_note"] = "Package name not provided; install was tested but launch was skipped."

    screenshot_result = run(adb_cmd(adb, serial, ["exec-out", "screencap", "-p"]), timeout=30, binary=True)
    if screenshot_result["returncode"] == 0 and isinstance(screenshot_result["stdout"], bytes):
        (out_dir / "screenshot.png").write_bytes(screenshot_result["stdout"])
        summary["screenshot"] = str((out_dir / "screenshot.png").resolve())
    else:
        write_json(out_dir / "screenshot-error.json", screenshot_result)

    dump_result = run(adb_cmd(adb, serial, ["shell", "uiautomator", "dump", "/sdcard/window.xml"]), timeout=30)
    write_json(out_dir / "uiautomator-dump.json", dump_result)
    if dump_result["returncode"] == 0:
        pull_result = run(adb_cmd(adb, serial, ["pull", "/sdcard/window.xml", str(out_dir / "window.xml")]), timeout=30)
        write_json(out_dir / "uiautomator-pull.json", pull_result)
        if (out_dir / "window.xml").exists():
            summary["ui_xml"] = str((out_dir / "window.xml").resolve())

    logcat_result = run(adb_cmd(adb, serial, ["logcat", "-d", "-t", str(args.log_lines)]), timeout=45)
    (out_dir / "logcat.txt").write_text(logcat_result.get("stdout", ""), encoding="utf-8")
    summary["logcat"] = str((out_dir / "logcat.txt").resolve())

    summary["status"] = "pass"
    write_json(out_dir / "summary.json", summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
