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