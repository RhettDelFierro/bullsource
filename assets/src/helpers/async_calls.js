export async function signIn(cb,state) {
    return cb({
        variables: {
            username: state.username,
            password: state.password
        }
    })
}

