import React from 'react';
import styles from './style.css'

export const Tweets = ({toggle, hideTweets, tweets}) => {
    return (
        toggle ?
        <div className={styles['tweet-container']} onClick={toggle}>
            {tweets.map(tweet => <li key={tweet.id_str}><b>{tweet.user.name}</b> {tweet.fullText}
                <b>{tweet.retweetCount}</b></li>)}
        </div>
        :
            <div className={styles['hidden-tweet-container']}><i className="fa fa-twitter" aria-hidden="true"/> <i className="fa fa-caret-right" aria-hidden="true"/></div>

    )
};