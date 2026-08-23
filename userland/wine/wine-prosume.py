#!/usr/bin/env python3
"""Measure cross-platform Wine/Winelib interoperability without claiming false conversion."""
import argparse, json, os, platform, shutil, subprocess, sys


def run(cmd):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
        return {"available": True, "returncode": p.returncode, "stdout": p.stdout.strip(), "stderr": p.stderr.strip()}
    except (FileNotFoundError, subprocess.TimeoutExpired) as e:
        return {"available": False, "error": str(e)}


def kind(path):
    ext = os.path.splitext(path)[1].lower()
    if ext == ".so": return "elf-shared-object"
    if ext in (".dll", ".exe", ".sys", ".msi"): return "windows-pe-family"
    return "unknown"


def assess(path):
    k = kind(path)
    result = {"path": os.path.abspath(path), "input_kind": k, "native_conversion": None,
              "format": 0, "abi_api": 0, "dependencies": 0, "execution": 0, "observability": 0,
              "notes": []}
    if not os.path.exists(path):
        result["notes"].append("input does not exist")
        return result
    result["format"] = 2 if k != "unknown" else 0
    file_tool = shutil.which("file")
    if file_tool:
        result["file"] = run([file_tool, path])
    if k == "elf-shared-object":
        result["native_conversion"] = False
        result["notes"] += [
            "An ELF .so cannot be made into a native Windows .dll by renaming or copying.",
            "Use source-level rebuild/port or an explicit ABI bridge; measure exported symbols and dependencies first."]
        nm = shutil.which("nm")
        if nm:
            result["exports"] = run([nm, "-D", "--defined-only", path])
        result["abi_api"] = 1
        result["dependencies"] = 1
    elif k == "windows-pe-family":
        result["native_conversion"] = False
        wine = shutil.which("wine")
        result["wine"] = run([wine, "--version"]) if wine else {"available": False}
        result["execution"] = 2 if wine else 0
        result["abi_api"] = 2 if k == "windows-pe-family" else 0
        result["dependencies"] = 1
        result["notes"].append("PE execution is assessed through Wine; native Windows execution remains a separate target.")
    else:
        result["notes"].append("Use an explicit format/loader adapter before claiming interoperability.")
    result["observability"] = 2
    result["host"] = {"system": platform.system(), "release": platform.release(), "machine": platform.machine()}
    result["score"] = sum(result[x] for x in ("format", "abi_api", "dependencies", "execution", "observability"))
    result["max_score"] = 10
    return result


def main():
    ap = argparse.ArgumentParser(description="Prosume compatibility assessment for Wine/Winelib workloads")
    ap.add_argument("path")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()
    r = assess(args.path)
    if args.json:
        print(json.dumps(r, indent=2))
    else:
        print(f"Input: {r['path']}")
        print(f"Kind: {r['input_kind']}")
        print(f"Compatibility evidence: {r['score']}/{r['max_score']}")
        for n in r["notes"]: print(f"- {n}")
    return 0 if os.path.exists(args.path) else 2

if __name__ == "__main__":
    sys.exit(main())
