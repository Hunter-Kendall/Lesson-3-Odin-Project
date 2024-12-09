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

for (const pr of pullRequests.data) {
  let execOutput = ''
  let execError = ''

  const options = {
    listeners: {
      stdout: (data) => {
        execOutput += data.toString()
      },
      stderr: (data) => {
        console.log('here:', data.toString())
        execError += data.toString()
      },
    },
  }
  const { title, number, labels, head: { ref: branch } } = pr
  if (labels.some(label => label.name.toLowerCase() === 'staging')) {
    try {
      console.log('options: ', options)
      await exec('git', ['merge', `origin/${branch}`, '--squash', '--verbose'], options)
      await exec('git', ['commit', '-m', `${title} (#${number})`])
      console.log(execOutput)
    } catch(error) {
      console.log('exec error: ', execError)
      octokit.rest.issues.createComment({
        owner: github.context.repo.owner,
        repo: github.context.repo.repo,
        issue_number: number,
        body: `error: ${execError}`,
      })
      await exec('git restore --staged .')
      await exec('git restore .')
      await exec('git clean -df')
    }
  }
}
await exec('git push --force')


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
