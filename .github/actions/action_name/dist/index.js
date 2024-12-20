import * as core from '@actions/core'
import * as github from '@actions/github'
import { exec } from '@actions/exec'

const token = core.getInput('github-token', { required: true })
// const primaryBranch = core.getInput('primary-branch', { required: true })
const octokit = github.getOctokit(token)


const pullRequests = await octokit.rest.pulls.list({
  ...github.context.repo,
  state: 'open',
  sort: 'created',
  direction: 'asc',
})
await exec('git config --global user.email "github-actions@github.com"')
await exec('git config --global user.name "github-actions"')
await exec('git', ['reset', '--hard', 'origin/main'])

function extractFilenamesFromConflicts(logText) {
  // Use a regular expression to match filenames following "CONFLICT (content): Merge conflict in"
  const regex = /CONFLICT \(content\): Merge conflict in\s+([^\n]+)/g
  const matches = []
  let match

  // Use a loop to find all matches
  while ((match = regex.exec(logText)) !== null) {
    matches.push(match[1]) // Capture the filename
  }

  return matches
}

function formatCommentBody(mergeConflictMessage, consoleErrorMessage){
  const formattedConflictFiles = extractFilenamesFromConflicts(mergeConflictMessage).join('\n')

  let conflictMessage = `Merge Conflicts in these files:\n${formattedConflictFiles}`
  if (consoleErrorMessage) {
    conflictMessage += `\n\nMerge Command Error: ${consoleErrorMessage}`
  }
  return conflictMessage
}

for (const pr of pullRequests.data) {
  let execOutput = ''
  let execError = ''
  const options = {
    listeners: {
      stdout: (data) => {
        execOutput += data.toString()
      },
      stderr: (data) => {
        execError += data.toString()
      },
    },
  }

  const { title, number, labels, head: { ref: branch } } = pr
  if (labels.some(label => label.name.toLowerCase() === 'staging')) {
    try {
      await exec('git', ['merge', `origin/${branch}`, '--squash', '--verbose'], options)
      await exec('git', ['commit', '-m', `${title} (#${number})`])
    } catch(error) {
      await exec('git restore --staged .')
      await exec('git restore .')
      await exec('git clean -df')
      octokit.rest.issues.createComment({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        issue_number: number,
        body: formatCommentBody(execOutput, execError),
      })
    }
  }
}

await exec('git push --force')

// Removing staging labels from closed PRs
const closedPullRequests = await octokit.rest.pulls.list({
  ...github.context.repo,
  state: 'closed',
  sort: 'created',
  direction: 'asc',
})

const repoLabels = await octokit.rest.issues.listLabelsForRepo({
  owner: github.context.repo.owner,
  repo: github.context.repo.repo,
});

const stagingLabelName = repoLabels.data.find(label => label.name.toLowerCase() === 'staging').name

for (const closedPr of closedPullRequests.data) {
  const { number, labels } = closedPr
  if (labels.some(label => label.name.toLowerCase() === 'staging')) {
    octokit.rest.issues.removeLabel({
      owner: github.context.repo.owner,
      repo: github.context.repo.repo,
      issue_number: number,
      name: stagingLabelName,
    })
  }
}
