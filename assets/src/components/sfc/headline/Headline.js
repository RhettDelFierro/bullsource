import React from "react";
import moment from "moment";
import {Link} from "react-router-dom";

import styles from "./style.css";

import TweetsContainer from "../../content/tweets_container/tweets_container";

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
            <div className={styles['image-holder']}>
                <img className={styles["img-thumbnail"]} width="100" height="100" src={news.urlToImage}/>
            </div>
            <div className={styles.info}>
                <Link to={`/category/${network.category}/${network.id}/${title}`}>
                    {news.title}
                </Link>
                <p><b>Network</b>: <a href={network.url} target="_blank">{network.name}</a></p>
                <p>{time}</p>
                <div>
                    <p>
                        <span style={{color: "#F15A24"}}>comments</span> {' '}
                        <span style={{color: "rgb(119,253,119)"}}>Bullsourced</span>{' '}
                        <span style={{color: "#977B52"}}>^%$^</span>
                    </p>
                </div>
            </div>


            <TweetsContainer tweets={tweets}/>
        </div>
    )
}



