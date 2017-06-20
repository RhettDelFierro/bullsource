import React, {Component} from "react";
import {graphql} from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import signInMutation from "../../mutations/signin";

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

    onSubmit(event) {
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
        this.props.mutate({
            variables: {
                username: this.state.username,
                password: this.state.password
            },
            // refetchQueries: [{query: currentUser}]
        }).then((response) => {
            const {user, token} = response.data.loginUser;

            localStorage.setItem('token', token);
            this.setState({
                username: '',
                password: '',
                validationMessage: `Welcome back ${user.username}!`,
                validationError: ''
            });

            this.props.history.push("/");
        })
            .catch((e) => {
                if (e.graphQLErrors[0].message === "In field \"loginUser\": No user with this username was found!" ||
                    e.graphQLErrors[0].message === "In field \"loginUser\": Incorrect password") {
                    this.setState({usernameError: "No user with this username was found!"})
                }
                this.setState({
                    validationError: 'Invalid Username and/or password.'
                })
            })
    }

    render() {
        let message = this.state.validationMessage || "Sign In!";
        return (
            <div>
                <Link to="/">Back</Link>
                <h3>{message}</h3>
                <p style={{color: "red"}}>{this.state.validationError}</p>

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


                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}


export default graphql(signInMutation)(withRouter(SignIn));