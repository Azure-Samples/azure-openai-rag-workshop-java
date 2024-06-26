#!/usr/bin/env bash
##############################################################################
# Usage: ./create-packages.sh
# Creates packages for skippable sections of the workshop
##############################################################################

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

target_folder=dist

rm -rf "$target_folder"
mkdir -p "$target_folder"

copyFolder() {
  local src="$1"
  local dest="$target_folder/${2:-}"
  find "$src" -type d -not -path '*node_modules*' -not -path '*/.git' -not -path '*.git/*' -not -path '*/dist' -not -path '*dist/*' -exec mkdir -p '{}' "$dest/{}" ';'
  find "$src" -type f -not -path '*node_modules*' -not -path '*.git/*' -not -path '*dist/*' -not -path '*/.DS_Store' -exec cp -r '{}' "$dest/{}" ';'
}

makeArchive() {
  local src="$1"
  local name="${2:-$src}"
  local archive="$name.tar.gz"
  local cwd="${3:-}"
  echo "Creating $archive..."
  if [[ -n "$cwd" ]]; then
    pushd "$target_folder/$cwd" >/dev/null
    tar -czvf "../$archive" "$src"
    popd
    rm -rf "$target_folder/${cwd:?}"
  else
    pushd "$target_folder/$cwd" >/dev/null
    tar -czvf "$archive" "$src"
    popd
    rm -rf "$target_folder/${src:?}"
  fi
}

##############################################################################
# Complete solution
##############################################################################
echo "Creating solution package (for Java + Quarkus)..."
copyFolder . solution-java-quarkus
rm -rf "$target_folder/solution-java-quarkus/.azure"
rm -rf "$target_folder/solution-java-quarkus/.qdrant"
rm -rf "$target_folder/solution-java-quarkus/.env"
rm -rf "$target_folder/solution-java-quarkus/.env*"
rm -rf "$target_folder/solution-java-quarkus/docs"
rm -rf "$target_folder/solution-java-quarkus/trainer"
rm -rf "$target_folder/solution-java-quarkus/scripts/repo"
rm -rf "$target_folder/solution-java-quarkus/.github"
rm -rf "$target_folder/solution-java-quarkus/TODO"
rm -rf "$target_folder/solution-java-quarkus/SUPPORT.md"
rm -rf "$target_folder/solution-java-quarkus/CODE_OF_CONDUCT.md"
rm -rf "$target_folder/solution-java-quarkus/SECURITY.md"
rm -rf "$target_folder/solution-java-quarkus/scripts/setup-template.sh"
perl -pi -e 's/stream: false/stream: true/g' "$target_folder/solution-java-quarkus/src/frontend/src/components/chat.ts"
perl -pi -e 's/qdrant:6333/qdrant:6334/g' "$target_folder/solution-java-quarkus/docker-compose.yml"
makeArchive . solution-java-quarkus solution-java-quarkus

##############################################################################
# Frontend
##############################################################################

echo "Creating frontend package..."
copyFolder src/frontend
makeArchive src frontend

##############################################################################
# Deployment (CI/CD)
##############################################################################

echo "Creating CI/CD package..."
mkdir -p "$target_folder/ci-cd/.github/workflows"
cp .github/workflows/deploy.yml "$target_folder/ci-cd/.github/workflows/deploy.yml"
makeArchive . ci-cd ci-cd
