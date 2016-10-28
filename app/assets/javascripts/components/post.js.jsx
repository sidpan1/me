var Post = React.createClass({
  propTypes: {
    title: React.PropTypes.string,
    content: React.PropTypes.string
  },

  render: function() {
    return (
      <div>
        <div>Title: {this.props.title}</div>
        <div>Content: {this.props.content}</div>
      </div>
    );
  }
});
