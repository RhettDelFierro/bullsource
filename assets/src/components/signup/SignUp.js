import React, {Component} from "react";
import {graphql, withApollo} from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import currentUserQuery from "../../queries/currentUser";
import signUpMutation from "../../mutations/signup";
import {signUpAPI} from "../../helpers/async_calls";

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
            validationErrors: []
        };
    }

    componentWillUpdate(nextProps) {
        if (!this.props.data.currentUser && nextProps.data.currentUser) {
            this.props.history.push("/");
        }
    }


    async onSubmit(event) {
        event.preventDefault();
        if (this.state.password !== this.state.confirm_password) {
            let passwordError = "The passwords you've entered do not match.";
            this.setState({
                validationErrors: [passwordError]
            });
            return
        }

        try {
            this.setState({
                validationErrors: []
            });
            //register and authenticate user - sets jwt.
            await signUpAPI(this.props.mutate, this.state);
            this.props.client.resetStore();
        }
        catch (e) {
            const errors = e.graphQLErrors[0].error_list.map((error) => {
                return `${Object.keys(error)[0]} ${error[Object.keys(error)[0]]}`;
            });

            this.setState({validationErrors: errors})
        }

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

                    {this.state.validationErrors.map(error => {
                        return <p style={{color: "red"}}>{error}</p>
                    })}
                    <input type="submit" onClick={this.onSubmit.bind(this)}/>
                </form>
            </div>
        )

    }
}


export default withApollo(
    graphql(signUpMutation)(
        graphql(currentUserQuery)(
            withRouter(SignUp)
        )
    )
);