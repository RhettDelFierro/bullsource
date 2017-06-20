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
            email: '',
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
                email: this.state.email,
                password: this.state.password
            },
            refetchQueries: [{query: newsTweetQuery}]
        }).then((response) => {
            let token = response.data.loginUser.token;
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
                <h3>Sign In!</h3>
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

                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}



export default graphql(signInMutation)(withRouter(SignIn));