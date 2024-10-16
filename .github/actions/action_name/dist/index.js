import * as core from '@actions/core'
import * as github from '@actions/github'
import { exec } from '@actions/exec'

const token = core.getInput('github-token', { required: true })
const octokit = github.getOctokit(token)
// octokit.rest.issues.createComment({
//   owner: github.context.repo.owner,
//   repo: github.context.repo.repo,
//   issue_number: 1,
//   body: 'This PR sucks!'
// })

const pullRequests = await octokit.rest.pulls.list({
  ...github.context.repo,
  state: 'open',
  sort: 'created',
  direction: 'asc',
})
await exec('git config --global user.email "github-actions@github.com"')
await exec('git config --global user.name "github-actions"')
await exec('git checkout staging')
await exec('git reset --hard origin/main')

for (const pr of pullRequests.data) {
  const { title, number, labels, head: { ref: branch } } = pr
  if (labels.some(label => label.name.toLowerCase() === 'staging')) {
    try {
      await exec('git', ['merge', `origin/${branch}`, '--squash'])
      await exec('git', ['commit', '-m', `${title} (#${number})`])
    } catch {
      await exec('git restore --staged .')
      await exec('git restore .')
      await exec('git clean -df')
      octokit.rest.issues.createComment({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        issue_number: number,
        body: 'This branch could not be automatically added to staging due to merge conflicts.'
      })
    }
  }
}
await exec('git push --force')
