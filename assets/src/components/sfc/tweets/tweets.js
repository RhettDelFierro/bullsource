import React from "react";
import styles from "./style.css";
import {Tweet} from "react-twitter-widgets";

export const Tweets = ({toggle, showTweets, tweets}) => {
    return (
        showTweets ?
            <div className={styles['tweet-container']}>
                <div>
                    {tweets.map(tweet => {
                        return (
                            <div className={styles['returned-tweet']}><Tweet key={tweet.id_str}
                                        tweetId={tweet.id_str}
                                        options={{
                                            cards: "hidden",
                                            hide_thread: "true",
                                            conversation: "none"
                                        }}/>
                            </div>
                        )
                    })}
                </div>
                <i className="fa fa-caret-right" aria-hidden="true" onClick={toggle}
                   style={{"gridArea": "1 / 1 / 2 / 3"}}/>
            </div>
            :
            <div className={styles['hidden-tweet-container']} onClick={toggle}>
                <i className="fa fa-caret-left" aria-hidden="true"/>
                {tweets.length}
                <i className="fa fa-twitter" aria-hidden="true" style={{color: "#4AB3F4"}}/>
            </div>
    )
};