import React, {Component} from "react";
import {NavLink} from "react-router-dom";
import {graphql, withApollo} from "react-apollo";
import styles from "./style.css";

import currentUserQuery from "../../../queries/currentUser";
import signOutMutation from "../../../mutations/signout";

import screenSize from "../../hoc/screenSize";

class UserPanel extends Component {
    onLogout() {
        this.props.mutate({}).then((res) => {
            // res.data.signOut.id and res.data.signOut.username
            localStorage.removeItem('token');
            this.props.client.resetStore();
        })
    }

    renderStatus() {
        const {loading, currentUser} = this.props.data;
        if (loading) {
            return <div />
        }
        if (currentUser) {
            return (
                <div>
                    <div className={styles.user}>Welcome {currentUser.username}</div>

                    <div className={styles.logout} onClick={this.onLogout.bind(this)}>
                        Log Out
                    </div>

                </div>
            )
        } else {
            return (
                <ul>
                    <li>
                        <NavLink activeClassName={styles.active} to='/signup'>Sign-Up</NavLink>
                    </li>
                    <li>
                        <NavLink activeClassName={styles.active} to='/signin'> Sign-In</NavLink>
                    </li>
                </ul>
            )
        }
    }

    render() {
        return (
            <div className={styles['user-panel']}>
                {this.renderStatus()}
            </div>
        )
    }
}

export default withApollo(graphql(signOutMutation)(graphql(currentUserQuery)(screenSize(UserPanel))));

