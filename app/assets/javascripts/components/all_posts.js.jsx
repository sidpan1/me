var AllPosts = React.createClass({
    getInitialState() {
        return { posts: [] }
    },
    componentDidMount() {
        $.getJSON('/api/posts', (response) => { this.setState({ posts: response }) });
    },
    render() {

        var posts = this.state.posts.map((post) => {
                return (
                    <a href="#" className="list-group-item">
                        <h4 className="list-group-item-heading">{post.title}</h4>
                        <p className="list-group-item-text">{post.content}</p>
                    </a>
                )
            }
        );

        return (
            <div className="list-group">
                {posts}
            </div>
        );
    }
});
