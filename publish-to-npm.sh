echo "📦  Bumping version (${BUMP_TYPE})…"
# this will update package.json, create a commit, and tag it
npm version "$BUMP_TYPE" -m "chore: release v%s"

echo "📤  Pushing branch '$CURRENT_BRANCH' and tags to origin…"
git push origin "$CURRENT_BRANCH" --follow-tags

echo "🚀  Publishing to npm…"
npm publish --access public

NEW_VERSION=$(node -e "console.log(require('./package.json').version)")
echo "✅  Successfully published log-it@${NEW_VERSION}"