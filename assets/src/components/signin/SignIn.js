import React, {Component} from "react";
import {withApollo,graphql} from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import {signInAPI} from "../../helpers/async_calls";
import signInMutation from "../../mutations/signin";
import currentUser from "../../queries/currentUser";

class SignIn extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            password: '',
            validationMessage: '',
            validationErrors: []
        };
    }

    componentWillUpdate(nextProps) {
        //after a user has signed on, they will be redirected to the home page.
        //will also protect a signed in user form going to /signin
        if (!this.props.data.currentUser && nextProps.data.currentUser) {
            this.props.history.push("/");
        }
    }

    async onSubmit(event) {
        event.preventDefault();
        try {
            // signIn authenticates and sets jwt token.
            await signInAPI(this.props.mutate, this.state);
            this.props.client.resetStore();
        }
        catch (e) {
            const errors = e.graphQLErrors.map((error) => {
                return error.message.split(": ")[1];
            });
            this.setState({validationErrors: errors})
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
    graphql(currentUser)(
        graphql(signInMutation)(
            withRouter(SignIn)
        )
    )
);