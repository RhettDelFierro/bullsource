export async function signInAPI(cb, {username, password}) {
    const mutation = await cb(
        {
            variables: {username, password},
            // refetchQueries: [{query}]
        });

    localStorage.setItem('token', mutation.data.loginUser.token);
}

export async function signUpAPI(cb, {username, email, password}) {
    const mutation = await cb({variables: {username, email, password}});
    localStorage.setItem('token', mutation.data.registerUser.token)
}

export async function signOutAPI(cb, resetFunc) {
    await cb({});
    localStorage.removeItem('token');
}

export async function createPost(cb, state) {
    const {title, network, topicId, url,
           description, publishedAt, post} = state;
    const mutation = await cb({
        variables: {
            title,
            network,
            topicId,
            url,
            description,
            publishedAt,
            post
        }
    })
    //then use the mutation object or just use reftech queries to get the posts from the db and re-render?
}