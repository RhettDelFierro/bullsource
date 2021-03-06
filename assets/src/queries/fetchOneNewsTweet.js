import gql from 'graphql-tag'

export default gql`
    query NewsTweet($title: String!){
        newsTweet(title: $title) {
            network{
                id
                name
                url
                category
            }
            news{
                title
                url
                urlToImage
                publishedAt
                description
            }
            tweets{
                retweetCount,
                id_str,
                fullText,
                user{
                    name
                },
                retweeted
            }
        }
        currentUser{
            id
        }
    }
`;