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

await exec('git checkout staging')
await exec('git reset --hard origin/main')

for (const pr of pullRequests.data) {
  const { title, number, head: { ref: branch } }= pr
  await exec('git', ['merge', branch, '--squash'])
  await exec('git', ['commit', '-m', `${title} (#${number})`])
}
await exec('git push --force')
