import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import newsTweetQuery from "../../queries/fetchNewsTweets";
import signUpMutation from "../../mutations/signup"

class SignUp extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            email: '',
            password: '',
            confirm_password: '',
            usernameError: '',
            emailError: '',
            passwordError: '',
            confirmPasswordError: ''
        };
    }

    onSubmit(event) {
        event.preventDefault();
        if(this.state.password !== this.state.confirm_password) {
            let passwordErrors = "The passwords you've entered do not match.";

            this.setState({
                passwordError: passwordErrors,
                confirmPasswordError: passwordErrors

            });
            return
        }
        //attempt mutation:
        this.props.mutate({
            variables: {
                username: this.state.username,
                email: this.state.email,
                password: this.state.password
            },
            refetchQueries: [{query: newsTweetQuery}]
        }).then((response) => {
            let token = response.data.registerUser.token;
            localStorage.setItem('token', token);
            this.props.history.push("/");
        })
            .catch((e) => {
                console.log('error', e);
            })
    }

    render() {

        return (
            <div>
                <Link to="/">Back</Link>
                <h3>Sign up!</h3>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Username</label>
                    <input type="text"
                           onChange={event => this.setState({username: event.target.value})}
                           value={this.state.username}
                    />

                    <label>Email</label>
                    <input type="text"
                           onChange={event => this.setState({email: event.target.value})}
                           value={this.state.email}
                    />

                    <label>Password</label>
                    <input type="password"
                           onChange={event => this.setState({password: event.target.value})}
                           value={this.state.password}
                    />
                    <p>{this.state.passwordError}</p>

                    <label>Confirm Password</label>
                    <input type="password"
                           onChange={event => this.setState({confirm_password: event.target.value})}
                           value={this.state.confirm_password}
                    />
                    <p>{this.state.confirmPasswordError}</p>
                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}



export default graphql(signUpMutation)(withRouter(SignUp));