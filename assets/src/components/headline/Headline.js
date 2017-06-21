import React from "react";
import moment from "moment";
import { Link } from 'react-router-dom';

import styles from "./style.css";



/**
 * Is an SFC - this will create each Headline and is a child component of Home and Category components.
 *
 * Parameters:
 *
 * newsTweets :: Object
 *   network :: Object
 *     id       :: String - the network id name
 *     name     :: String - name of the network
 *     url      :: String - url of the network's site
 *     category :: String - category of the network
 *
 *   news    :: Object
 *     title       :: String - title of the article
 *     url         :: String - url link to the article on the network's site
 *     urlToImage  :: String - url of news image
 *     publishedAt :: String - time the headline was published.
 *
 *   tweets  :: [Object]
 *     retweetCount  :: Integer - number of times the tweet has been retweeted
 *     id_str        :: String  - id of the tweet
 *     fullText      :: String  - text of the tweet
 *     user          :: Object  - user of the tweet
 *       name        :: String  - username of user
 *     retweeted     :: Bool    - if this is a retweet
 *
 *
 * Returns:
 * <div>
 */
export default ({newsTweet}) => {

    const {network, news, tweets} = newsTweet;
    const title = news.title.split(" ").join('_');
    const utcTime = moment.utc(news.publishedAt).fromNow();
    const time = utcTime === "Invalid date" ? news.publishedAt : utcTime;
    return (
        <div className={styles.headline} key={`${network.id}${news.title}`}>
            <div>
                <img className={styles["img-thumbnail"]} width="100" height="100" src={news.urlToImage}/>
            </div>
            <Link to={`/category/${network.category}/${title}`}>
                <p><b>{network.name}</b> {news.title}</p>
            </Link>
            <p>{time}</p>

            <TweetContainer tweets={tweets} />
        </div>
    )
}

const TweetContainer = ({tweets}) => {
    return (
        <div>
            {tweets.map(tweet => <li key={tweet.id_str}><b>{tweet.user.name}</b> {tweet.fullText}
                <b>{tweet.retweetCount}</b> {`${tweet.retweeted}`}</li>)}
        </div>

    )
};

