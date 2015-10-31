var Header = React.createClass({
  render: function() {
    var Navbar = ReactBootstrap.Navbar;
    var NavBrand = ReactBootstrap.NavBrand;
    var Nav = ReactBootstrap.Nav;
    var NavItem = ReactBootstrap.NavItem;

    return (
      <Navbar>
        <NavBrand>iRonhead</NavBrand>
        <Nav right>
          <NavItem eventKey={1} href="#">Link</NavItem>
          <NavItem eventKey={2} href="#">Link</NavItem>
        </Nav>
      </Navbar>
    );
  }
});

var DummyDocument = React.createClass({
  render: function() {
    var PageHeader = ReactBootstrap.PageHeader;

    return (
      <div>
        <PageHeader>{this.props.doc.name}</PageHeader>
        <div>
          Document type <strong>{
            this.props.doc.document_type
          }</strong> is not implemented!
          </div>
      </div>
    )
  }
});

var Image = React.createClass({
  render: function() {
    var PageHeader = ReactBootstrap.PageHeader;
    var BImage = ReactBootstrap.Image;

    return (
      <div>
        <PageHeader>{this.props.doc.name}</PageHeader>
        <BImage src={ this.props.doc.url } responsive />
      </div>
    );
  }
});

var Shelf = React.createClass({
  handleClick: function(doc) {
    this.props.container.loadDocument(doc.url);
  },

  render: function() {
    var PageHeader = ReactBootstrap.PageHeader;
    var Table = ReactBootstrap.Table;

    return (
      <div>
        <PageHeader>{this.props.doc.name}</PageHeader>
        <Table striped bordered hover>
          <thead>
            <tr><th>Title</th><th>Type</th></tr>
          </thead>
          <tbody>{
            this.props.doc.documents.map(function(doc, index) {
              return (
                <tr key={ index } onClick={ this.handleClick.bind(this, doc) } >
                  <td>{ doc.name }</td>
                  <td>{ doc.document_type }</td>
                </tr>
              );
            }.bind(this))
          }
          </tbody>
        </Table>
      </div>
    );
  }
});

var Youtube = React.createClass({
  render: function() {
    var PageHeader = ReactBootstrap.PageHeader;
    var ResponsiveEmbed = ReactBootstrap.ResponsiveEmbed;

    // FIXME: iframe bug, check console.

    return (
      <div>
        <PageHeader>{this.props.doc.name}</PageHeader>
        <ResponsiveEmbed a16by9>
          <iframe src={ this.props.doc.url } allowFullScreen></iframe>
        </ResponsiveEmbed>
      </div>
    );
  }
});

var Container = React.createClass({
  loadDocument: function(url) {
    $.ajax({
      url: url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({ doc: data });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  getInitialState: function() {
    return { doc: { document_type: "unknown" } };
  },

  componentDidMount: function() {
    this.loadDocument(this.props.url);
  },

  render: function() {
    switch (this.state.doc.document_type) {
      case "image":
        return (<Image doc={ this.state.doc } />);
      case "shelf":
        return (<Shelf doc={ this.state.doc } container={ this } />);
      case "youtube":
        return (<Youtube doc={ this.state.doc } />);
      default:
        return (<DummyDocument doc={ this.state.doc } />);
    }
  }
});

ReactDOM.render(<Header />, document.getElementById('navbar'));
ReactDOM.render(<Container url="/target/shelves/shelves_0.json" />, document.getElementById('shelf'));
