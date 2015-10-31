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

var PageHeader = React.createClass({
  render: function() {
    var BButton = ReactBootstrap.Button;
    var BPageHeader = ReactBootstrap.PageHeader;
    var BImage = ReactBootstrap.Image;

    return (
      <BPageHeader>
        { this.props.doc.name }
        {
          (() => {
            if (this.props.doc.parent_url) {
              return (
                <BButton bsStyle="link"
                         className="pull-right"
                         onClick={ this.props.container.handleUrl(this.props.doc.parent_url) }>
                  Back
                </BButton>
              )
            }
          })()
        }
      </BPageHeader>
    )
  }
});

var DummyDocument = React.createClass({
  render: function() {
    return (
      <div>
        <PageHeader doc={ this.props.doc } container={ this.props.container } />
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
    var BCarousel = ReactBootstrap.Carousel;
    var BCarouselItem = ReactBootstrap.CarouselItem;
    var BImage = ReactBootstrap.Image;

    return (
      <div>
        <PageHeader doc={ this.props.doc } container={ this.props.container } />
        {
          (() => {
            if (this.props.doc.urls) {
              return (
                <BCarousel>
                  { this.props.doc.urls.map(function(url, index) {
                    return (
                      <BCarouselItem key={ index }>
                        <img className="center-block" src={ url } />
                      </BCarouselItem>
                    );
                  }) }
                </BCarousel>
              )
            } else {
              return (<BImage src={ this.props.doc.url } responsive />);
            }
          })()
        }
        <div><p>{ this.props.doc.description }</p></div>
      </div>
    );
  }
});

var Shelf = React.createClass({
  render: function() {
    var Table = ReactBootstrap.Table;

    return (
      <div>
        <PageHeader doc={ this.props.doc } container={ this.props.container } />
        <Table striped bordered hover>
          <thead>
            <tr><th className="col-lg-10">Title</th><th className="col-lg-2">Type</th></tr>
          </thead>
          <tbody>{
            this.props.doc.documents.map(function(doc, index) {
              return (
                <tr key={ index } onClick={ this.props.container.handleUrl(doc.url) } >
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
    var ResponsiveEmbed = ReactBootstrap.ResponsiveEmbed;

    // FIXME: iframe bug, check console.

    return (
      <div>
        <PageHeader doc={ this.props.doc } container={ this.props.container } />
        <ResponsiveEmbed a16by9>
          <iframe src={ this.props.doc.url } allowFullScreen></iframe>
        </ResponsiveEmbed>
      </div>
    );
  }
});

var Container = React.createClass({
  handleUrl: function(url) {
    return function(url_) {
      this.loadDocument(url_);
    }.bind(this, url);
  },

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
        return (<Image doc={ this.state.doc } container={ this } />);
      case "shelf":
        return (<Shelf doc={ this.state.doc } container={ this } />);
      case "youtube":
        return (<Youtube doc={ this.state.doc } container={ this } />);
      default:
        return (<DummyDocument doc={ this.state.doc } container={ this } />);
    }
  }
});

ReactDOM.render(<Header />, document.getElementById('navbar'));
ReactDOM.render(<Container url="./target/shelves/shelves_0.json" />, document.getElementById('shelf'));
