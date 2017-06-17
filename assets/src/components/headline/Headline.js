import React from "react";


/**
* SFC - this will create each headline. Is child component of Home, Category, and Discussion components.
*
*
*
* Parameters:
*
* newsTweets  :: Object
*   network
*     id   :: String - the network id name
*     name :: String - name of the network
*     url  :: String - url of the network's site
 *
*   news
*     title       :: String - title of the article
*     url         :: String - url link to the article on the network's site
*     urlToImage  :: String - url of news image
*     publishedAt :: String - time the headline was published.
 *
*   tweets          :: [Object]
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
export default ({ newsTweet }) => {

    const { network, news, tweets } = newsTweet;

    return (
        <div className="headline" key={`${network.id}${news.title}`}>
            <img src={news.urlToImage} />
            <p><b>{network.name}</b> {news.title}</p>
            <div>
                {tweets.map(tweet => <li key={tweet.id_str}><b>{tweet.user.name}</b> {tweet.fullText} <b>{tweet.retweetCount}</b> {`${tweet.retweeted}`}</li>)}
            </div>
        </div>
    )
}

