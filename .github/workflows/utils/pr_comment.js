module.exports = async ({github, context, core}) => {
    const {BRANCH_SHA} = process.env
    const {WORKLOAD_VERSION} = process.env
    const {IMAGE_TAG} = process.env

    // 1. Retrieve existing bot comments for the PR
    const {data: comments} = await github.rest.issues.listComments({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
    })
    const botComment = comments.find(comment => {
        return comment.user.type === 'Bot' && comment.body.includes('Pipeline Data 📋️️')
    })

// 2. Prepare the format of the comment
    const output = `
        #### Pipeline Data 📋️️

        Branch sha: ${BRANCH_SHA}
        Workload version: ${WORKLOAD_VERSION}
        Image tag: ${IMAGE_TAG}
    `;

// 3. If we have a comment, update it, otherwise create a new one
    if (botComment) {
        github.rest.issues.updateComment({
            owner: context.repo.owner,
            repo: context.repo.repo,
            comment_id: botComment.id,
            body: output
        })
    } else {
        github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: output
        })
    }
}
