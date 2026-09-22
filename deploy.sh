#!/bin/sh
# index.html 을 Cloudflare 에 배포한다.
#
#   ./deploy.sh              배포
#   ./deploy.sh --preview    로컬 미리보기(http://localhost:8787), 배포는 안 함
#
# 배포 대상은 ./public 폴더뿐이다. Diet/, recording_weight/ 의 원본 기록은
# 업로드되지 않는다. (public 을 명시적으로 만들어 담는 방식이라 실수로 섞일 수 없음)

set -eu
cd "$(dirname "$0")"

if [ ! -f index.html ]; then
  echo "index.html 이 없습니다: $(pwd)" >&2
  exit 1
fi

# --- build: 배포할 것만 public/ 에 담는다 -----------------------------------
rm -rf public
mkdir -p public
cp index.html public/index.html
echo "build: public/index.html ($(wc -c < public/index.html | tr -d ' ') bytes)"

# --- deploy -----------------------------------------------------------------
if ! command -v wrangler >/dev/null 2>&1; then
  echo "wrangler 가 없습니다. 먼저 설치하세요:  npm install -g wrangler" >&2
  exit 1
fi

if [ "${1:-}" = "--preview" ]; then
  echo "로컬 미리보기를 시작합니다. 종료는 Ctrl+C."
  exec wrangler dev
fi

wrangler deploy
