import * as core from '@actions/core'
import * as github from '@actions/github'

const token = core.getInput('github-token', { required: true })
const octokit = github.getOctokit(token)
octokit.rest.issues.createComment({
  owner: github.context.repo.owner,
  repo: github.context.repo.repo,
  issue_number: 1,
  body: 'This PR sucks!'
})
