import React, {Component} from "react";
import {NavLink} from "react-router-dom";
import {graphql, withApollo} from "react-apollo";
import styles from "./style.css";

import currentUserQuery from "../../../queries/currentUser";
import signOutMutation from "../../../mutations/signout";

import screenSize from "../../hoc/screenSize";
import {signOutAPI} from '../../../helpers/async_calls';

//I want this user panel to render an empty form if the user is not signed in
    // user info if they are
    // app info
class UserPanel extends Component {
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
                        <i className="fa fa-envelope-open" aria-hidden="true" />
                        <button className={styles.logout} onClick={this.onSignOut.bind(this)}>
                            Log Out
                        </button>
                    </div>
                )
        } else {
            //render forms / (links to signup/signin)?
            //I want these forms to render on the side, not on the main content page.
            //reddit makes a popup modal on mobile and on the main page.
            return (
                <div>
                    <div>
                        <NavLink activeClassName={styles.active} to='/signup'>Sign-Up</NavLink>
                    </div>
                    <div>
                        <NavLink activeClassName={styles.active} to='/signin'> Sign-In</NavLink>
                    </div>
                </div>
            )
        }
    }

    render() {
        console.log('did side panel get rendered?');
        return (
            <div className={styles['user-panel']}>
                {this.renderStatus()}
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

