Generate a git commit message for the current staged/unstaged changes.

Instructions:
1. Run `git status` to see what files are modified
2. Run `git diff` on the modified files to see the actual changes
3. Run `git log -5 --oneline` to see recent commit message style
4. Analyze the changes and generate a concise, descriptive commit message that:
   - Summarizes the nature of changes (fix, feature, docs, refactor, etc.)
   - Focuses on the "why" rather than just the "what"
   - Follows the repository's existing commit message style
   - Is 50-72 characters for the subject line
   - Includes additional context in the body if needed
5. Format the message and present it to the user to copy/paste into their git client

Do NOT create the commit - only generate and display the message text.
