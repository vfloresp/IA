class SearchBar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  render() {
    return (
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder="Selecciona una canción" aria-label="Recipient's username" name="searhBar"/>
                <div class="input-group-append">
                    <button class="btn" type="button">Seleccionar</button>
                </div>
            </div>
        </div>
    </div>
    );
  }
}

ReactDOM.render(
  <SearchBar />,
  document.getElementById('searchBar')
);