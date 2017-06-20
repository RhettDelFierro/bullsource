import React, {Component} from "react";
import {graphql} from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import signInMutation from "../../mutations/signin";
import currentUser from "../../queries/currentUser";

class SignIn extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            password: '',
            validationMessage: '',
            validationError: ''
        };
    }

    async onSubmit(event) {
        event.preventDefault();
        if (this.state.username === '') {
            this.setState({validationError: 'username cannot be blank'});
            return
        }
        if (this.state.password === '') {
            this.setState({validationError: 'password cannot be blank'});
            return
        }

        //attempt mutation:
        try {
            const mutation = await this.props.mutate({
                variables: {
                    username: this.state.username,
                    password: this.state.password
                },
            });

            const {user, token} = mutation.data.loginUser;

            this.setState({
                validationMessage: `Welcome back ${user.username}!`,
                validationError: ''
            });

            localStorage.setItem('token', token);

            await this.props.data.refetch();
            this.props.history.push("/");

        }
        catch (e) {
            if (e.graphQLErrors[0].message === "In field \"loginUser\": No user with this username was found!" ||
                e.graphQLErrors[0].message === "In field \"loginUser\": Incorrect password") {
                this.setState({
                    validationError: 'Invalid Username and/or password.'
                })
            }
        }
    }

    render() {
        let message = this.state.validationMessage || "Sign In!";
        return (
            <div>
                <Link to="/">Back</Link>
                <h3>{message}</h3>

                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Username</label>
                    <input type="text"
                           onChange={event => this.setState({username: event.target.value})}
                           value={this.state.username}
                    />

                    <label>Password</label>
                    <input type="password"
                           onChange={event => this.setState({password: event.target.value})}
                           value={this.state.password}
                    />

                    <p style={{color: "red"}}>{this.state.validationError}</p>
                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}


export default graphql(signInMutation)(graphql(currentUser)(withRouter(SignIn)));