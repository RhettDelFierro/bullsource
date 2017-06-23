import React from "react";
import {NavLink} from "react-router-dom";
import styles from "./style.css";
import screenSize from "../../hoc/screenSize";
import DropDown from "../dropdown/Dropdown";

const CategoryNav = ({isMobile}) => {
    return (
        isMobile ?
            <DropDown />
            :
            <div className={styles['category-nav']}>
                <NavLink exact className={styles['category-home']} activeClassName={styles.active} to='/'>Home</NavLink>
                <NavLink className={styles['category-entertainment']} activeClassName={styles.active} to='/category/entertainment'>Entertainment</NavLink>
                <NavLink className={styles['category-gaming']} activeClassName={styles.active} to='/category/gaming'>Gaming</NavLink>
                <NavLink className={styles['category-general']} activeClassName={styles.active} to='/category/general'>General</NavLink>
                <NavLink className={styles['category-music']} activeClassName={styles.active} to='/category/music'>Music</NavLink>
                <NavLink className={styles['category-politics']} activeClassName={styles.active} to='/category/politics'>Politics</NavLink>
                <NavLink className={styles['category-science']} activeClassName={styles.active} to='/category/science-and-nature'>Science and Nature</NavLink>
                <NavLink className={styles['category-sport']} activeClassName={styles.active} to='/category/sport'>Sport</NavLink>
                <NavLink className={styles['category-technology']} activeClassName={styles.active} to='/category/technology'>Technology</NavLink>
            </div>
    )
};

export default screenSize(CategoryNav);

