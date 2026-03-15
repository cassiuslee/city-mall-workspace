import pathlib
import re
import sys
import urllib.parse

import subprocess


ROOT = pathlib.Path(__file__).resolve().parent
LLMS_TXT = ROOT / "llms.txt"
OUT_DIR = ROOT / "apifox-md"


def _safe_filename(name: str) -> str:
    name = name.strip()
    if not name:
        return "doc.md"
    name = re.sub(r"[^A-Za-z0-9._-]+", "_", name)
    return name


def _extract_urls(llms_text: str) -> list[str]:
    urls = re.findall(r"\((https?://[^)\s]+)\)", llms_text)
    deduped: list[str] = []
    seen: set[str] = set()
    for u in urls:
        if u in seen:
            continue
        seen.add(u)
        deduped.append(u)
    return deduped


def _curl_download(url: str, dest: pathlib.Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    r = subprocess.run(
        ["curl", "-L", url, "-o", str(dest)],
        capture_output=True,
        text=True,
    )
    if r.returncode != 0:
        raise RuntimeError(f"curl failed for {url}: {r.stderr.strip()}")


def main() -> int:
    if not LLMS_TXT.exists():
        print(f"Missing {LLMS_TXT}", file=sys.stderr)
        return 1

    llms_text = LLMS_TXT.read_text("utf-8", errors="ignore")
    urls = _extract_urls(llms_text)
    if not urls:
        print("No markdown links found in llms.txt", file=sys.stderr)
        return 1

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    index_lines: list[str] = [
        "# Apifox Exported Markdown",
        "",
        "Source: https://s.apifox.cn/0e6ee326-d646-41bd-9214-29dbf47648fa/llms.txt",
        "",
        "## Files",
    ]

    for url in urls:
        parsed = urllib.parse.urlparse(url)
        basename = pathlib.PurePosixPath(parsed.path).name
        filename = _safe_filename(basename)
        dest = OUT_DIR / filename
        if dest.exists():
            alt = _safe_filename(pathlib.PurePosixPath(parsed.path).as_posix().strip("/").replace("/", "__"))
            if not alt.endswith(".md"):
                alt = alt + ".md"
            dest = OUT_DIR / alt

        _curl_download(url, dest)
        rel = dest.relative_to(ROOT).as_posix()
        index_lines.append(f"- [{dest.name}]({rel})")

    (ROOT / "index.md").write_text("\n".join(index_lines) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
