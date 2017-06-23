import React, {Component} from "react";
import styles from "./style.css";

class Hamburger extends Component {
    constructor(props) {
        super(props);
        this.state = {
            opened: false
        }
    }

    toggleHamburger() {
        this.setState({opened: !this.state.opened})
    }

    render() {
        const hamburgerClasses = this.state.opened ?
            `${styles['hamburger-container']} ${styles['hamburger-container-clicked']}`
            : styles['hamburger-container'];

        return (
            <div className={hamburgerClasses}
                 onClick={this.toggleHamburger.bind(this)}>
                <div className={styles.hamburger}/>
            </div>

        )
    }
}

export default Hamburger;