import React from "react";
import styles from './hamburger.css'

export const Hamburger = () => {
    return (
        <div className={styles['hamburger-container']}>
            <div className={styles.hamburger}></div>
        </div>

    )
};