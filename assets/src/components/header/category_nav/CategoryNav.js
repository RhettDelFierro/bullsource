import React from "react";
import {NavLink} from "react-router-dom";
import styles from "./style.css";
import screenSize from "../../hoc/screenSize";
import {Hamburger} from "../../sfc/hamburger/hamburger";

const CategoryNav = ({isMobile}) => {
    return (
        isMobile ?
            <Hamburger />
            :
            <div className={styles['category-nav']}>
                <NavLink exact activeClassName={styles.active} to='/'>Home</NavLink>
                <NavLink activeClassName={styles.active} to='/category/entertainment'>Entertainment</NavLink>
                <NavLink activeClassName={styles.active} to='/category/gaming'>Gaming</NavLink>
                <NavLink activeClassName={styles.active} to='/category/general'>General</NavLink>
                <NavLink activeClassName={styles.active} to='/category/music'>Music</NavLink>
                <NavLink activeClassName={styles.active} to='/category/politics'>Politics</NavLink>
                <NavLink activeClassName={styles.active} to='/category/science-and-nature'>Science and
                    Nature</NavLink>
                <NavLink activeClassName={styles.active} to='/category/sport'>Sport</NavLink>
                <NavLink activeClassName={styles.active} to='/category/technology'>Technology</NavLink>
            </div>

    )
};

export default screenSize(CategoryNav);

