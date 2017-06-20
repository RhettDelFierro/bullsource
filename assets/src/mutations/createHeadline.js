import gql from "graphql-tag";

export default gql`
 mutation CreateHeadline($title: String!, $network: String!, $post: InputPost!, $topicId: Int!, 
                         $url: String!, $description: String, $publishedAt: String){
   createHeadline(title: $title, network: $network, post: $post, topicId: $topicId, 
                  url: $url, description: $description, publishedAt: $publishedAt) {
     description
     id
     network
     publishedAt
     title
     url
     posts{
       id
     }
   }
}
`;