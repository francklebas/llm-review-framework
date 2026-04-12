#!/bin/bash
# llm-review-framework installer
# Usage: curl -fsSL https://francklebas.com/llm-review | bash
#
# AGPL-3.0 — https://github.com/francklebas/llm-review-framework

set -euo pipefail

REPO="francklebas/llm-review-framework"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
INSTALL_DIR="$HOME/.llmfwk"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}>${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }
error()   { echo -e "${RED}✗${NC} $*" >&2; }

# --- Check dependencies ---
if ! command -v curl &>/dev/null; then
    error "curl is required but not installed."
    exit 1
fi

if ! command -v git &>/dev/null; then
    error "git is required but not installed."
    exit 1
fi

# --- Header ---
echo ""
echo -e "${BOLD}llm-review-framework${NC} installer"
echo -e "${CYAN}LLM-powered code review as a pre-commit hook${NC}"
echo ""

# --- Clean previous install ---
if [ -d "$INSTALL_DIR/bin" ] || [ -d "$INSTALL_DIR/prompts/base" ] || [ -d "$INSTALL_DIR/prompts/templates" ]; then
    info "Removing previous installation..."
    rm -rf "$INSTALL_DIR/bin" "$INSTALL_DIR/prompts/base" "$INSTALL_DIR/prompts/templates"
fi

# --- Create directory structure ---
info "Installing to $INSTALL_DIR"

mkdir -p "$INSTALL_DIR/bin"
mkdir -p "$INSTALL_DIR/prompts/base"
mkdir -p "$INSTALL_DIR/prompts/templates"
mkdir -p "$INSTALL_DIR/prompts/projects"

# --- Download files ---
info "Downloading..."

download() {
    local src="$1" dest="$2"
    curl -fsSL "$BASE_URL/$src" -o "$dest"
}

download "bin/llmfwk"         "$INSTALL_DIR/bin/llmfwk"
download "bin/llm-codereview" "$INSTALL_DIR/bin/llm-codereview"

download "prompts/base/codereview-context.md"    "$INSTALL_DIR/prompts/base/codereview-context.md"
download "prompts/base/codereview-guidelines.md" "$INSTALL_DIR/prompts/base/codereview-guidelines.md"

download "prompts/templates/codereview-context.md"    "$INSTALL_DIR/prompts/templates/codereview-context.md"
download "prompts/templates/codereview-guidelines.md" "$INSTALL_DIR/prompts/templates/codereview-guidelines.md"

chmod +x "$INSTALL_DIR/bin/llmfwk"
chmod +x "$INSTALL_DIR/bin/llm-codereview"

success "Files installed"

# --- Shell configuration ---
detect_shell_rc() {
    case "$(basename "${SHELL:-/bin/bash}")" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash)
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

RC_FILE=$(detect_shell_rc)
MARKER="# llm-review-framework"

if grep -q "$MARKER" "$RC_FILE" 2>/dev/null; then
    success "PATH already configured in $RC_FILE"
else
    echo ""
    info "To use llmfwk, it needs to be in your PATH."
    echo ""
    echo "  The following will be added to $RC_FILE:"
    echo -e "  ${CYAN}export LLMFWK_HOME=\"\$HOME/.llmfwk\"${NC}"
    echo -e "  ${CYAN}export PATH=\"\$LLMFWK_HOME/bin:\$PATH\"${NC}"
    echo ""
    echo -n "  Add to $RC_FILE? [Y/n]: "
    read -r answer
    answer="${answer:-y}"

    if [[ "$answer" =~ ^[Yy] ]]; then
        {
            echo ""
            echo "$MARKER"
            echo "export LLMFWK_HOME=\"\$HOME/.llmfwk\""
            echo "export PATH=\"\$LLMFWK_HOME/bin:\$PATH\""
        } >> "$RC_FILE"
        success "Added to $RC_FILE"
    else
        warn "Skipped. Add manually:"
        echo "  export LLMFWK_HOME=\"\$HOME/.llmfwk\""
        echo "  export PATH=\"\$LLMFWK_HOME/bin:\$PATH\""
    fi
fi

# --- Done ---
echo ""
echo -e "${GREEN}${BOLD}Installed!${NC}"
echo ""
echo "  Get started:"
echo "    1. Restart your terminal (or run: source $RC_FILE)"
echo "    2. cd into your project"
echo "    3. Run: llmfwk init"
echo ""
