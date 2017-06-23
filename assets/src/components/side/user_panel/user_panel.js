import React, {Component} from "react";
import {graphql, withApollo} from "react-apollo";
import styles from "./style.css";

import currentUserQuery from "../../../queries/currentUser";
import signOutMutation from "../../../mutations/signout";

import screenSize from "../../hoc/screenSize";
import {signOutAPI} from "../../../helpers/async_calls";

import SignIn from "../signin/SignIn";
import SignUp from "../signup/SignUp";

//I want this user panel to render an empty form if the user is not signed in
// user info if they are
// app info
class UserPanel extends Component {
    constructor(props) {
        super(props);
        this.state = {
            showSignIn: false,
            showSignUp: false
        }
    }

    toggleForms() {
        this.setState({
            showSignIn: false,
            showSignUp: false
        })
    }

    async onSignOut() {
        await signOutAPI(this.props.mutate);
        this.props.client.resetStore();
    }

    renderStatus() {
        const {loading, currentUser} = this.props.data;
        if (loading) {
            return <div />
        }
        if (currentUser) {
            //render the user panel:
            return (
                <div className={styles['current-user']}>
                    <div>Welcome {currentUser.username}</div>
                    <i className="fa fa-envelope-open" aria-hidden="true"/>
                    <button className={styles.logout} onClick={this.onSignOut.bind(this)}>
                        Log Out
                    </button>
                </div>
            )
        } else {
            return (
                <div className={styles['visitor']}>
                    <button onClick={() => this.setState({showSignIn: !this.state.showSignIn, showSignUp: false})}>
                        Sign In
                    </button>

                    <button onClick={() => this.setState({showSignUp: !this.state.showSignUp, showSignIn: false})}>
                        Sign up
                    </button>
                </div>
            )
        }
    }

    render() {
        return (
            <div className={styles['user-panel']}>
                {this.renderStatus()}
                {this.props.data.currentUser ? ''
                    : <div>
                        {this.state.showSignIn ? <SignIn /> : ''}
                        {this.state.showSignUp ? <SignUp /> : ''}
                      </div>
                }
                <div>UserInfo</div>
            </div>
        )
    }
}

export default withApollo(
    graphql(signOutMutation)(
        graphql(currentUserQuery)(
            screenSize(UserPanel)
        )
    )
);

