import React, {Component} from "react";
import { graphql } from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import newsTweetQuery from "../../queries/fetchNewsTweets";
import signInMutation from "../../mutations/signin"

class SignIn extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            password: '',
            signInError: ''
        };
    }

    onSubmit(event) {
        event.preventDefault();

        //attempt mutation:
        this.props.mutate({
            variables: {
                username: this.state.username,
                password: this.state.password
            },
            refetchQueries: [{query: newsTweetQuery}]
        }).then((response) => {
            let token = response.data.loginUser.token;
            localStorage.setItem('token', token);
            this.setState({
                username: '',
                password: '',
                signInError: ''
            });
            this.props.history.push("/");
        })
            .catch((e) => {
                this.setState({
                    signInError: 'Invalid Username and/or password.'
                })
            })
    }

    render() {

        return (
            <div>
                <Link to="/">Back</Link>
                <h3>Sign In!</h3>
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
                    <p>{this.state.signInError}</p>

                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}



export default graphql(signInMutation)(withRouter(SignIn));