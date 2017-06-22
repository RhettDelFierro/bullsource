import React from "react";
import styles from "./style.css";
import {Tweet} from 'react-twitter-widgets';

export const Tweets = ({toggle, showTweets, tweets}) => {
    return (
        showTweets ?
            <div className={styles['tweet-container']}>
                {tweets.map(tweet => <Tweet tweetId={tweet.id_str} options={{cards: "hidden"}}/>)}
                <i className="fa fa-caret-right" aria-hidden="true" onClick={toggle}/>
            </div>
            :
            <div className={styles['hidden-tweet-container']} onClick={toggle}>
                <i className="fa fa-caret-left" aria-hidden="true"/>

                <i className="fa fa-twitter" aria-hidden="true" style={{color: "#4AB3F4"}}/>
            </div>
    )
};