import React, {Component} from "react";
import styles from "./style.css";
import {withRouter, NavLink} from "react-router-dom";

class DropDown extends Component {
    constructor(props) {
        super(props);
        this.state = {
            opened: false
        }
    }

    toggleDropdown() {
        this.setState({opened: !this.state.opened})
    }

    render() {
        const dropDownClass = `${styles.overlay} ${styles["dropdown-content"]}`;
        const dropDownIcon = this.state.opened ?
            <i className="fa fa-caret-up" aria-hidden="true"/>
            : <i className="fa fa-caret-down" aria-hidden="true"/>;
        return (
            <div className={styles['dropdown-container']} onClick={this.toggleDropdown}>
                <div className={styles.dropdown} onClick={this.toggleDropdown.bind(this)}>
                    <i>Categories</i> {dropDownIcon}
                </div>
                {this.state.opened ?
                    <ul className={dropDownClass} onClick={this.toggleDropdown.bind(this)}>
                        <li><NavLink exact activeClassName={styles.active} to='/'>Home</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/entertainment'>Entertainment</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/gaming'>Gaming</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/general'>General</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/music'>Music</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/politics'>Politics</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/science-and-nature'>Science and
                            Nature</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/sport'>Sport</NavLink></li>
                        <li><NavLink activeClassName={styles.active} to='/category/technology'>Technology</NavLink></li>
                    </ul>
                    : ''
                }

            </div>

        )
    }
}

export default withRouter(DropDown);