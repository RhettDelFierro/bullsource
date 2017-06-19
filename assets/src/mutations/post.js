import gql from "graphql-tag";

export default gql`
 mutation CreatePost($thread_id: Int, $post: ){
  createPost(threadId: 133, post:{
    proofs:[{
      article: "4th proof in thread, 1st proof in 2nd article",
      comment: "4th proof in thread, 1st proof in 2nd comment",
      reference: {
        link: "http://snapchat.com",
        title: "graphql createpost3 title"
      }
    }],
    intro: "4th post in first graphql thread, made from createPost mutation."
  }){
    id
    upVotes{
      user{
        username
      }
    }
  }
}
`;