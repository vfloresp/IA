class Temporary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }
  

  render() {
    return (
    <div>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <input type="text" class="form-control" placeholder="id de inicio" aria-label="Recipient's username" name="idIni"/>
            </div>
        </div>
        <br></br>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <input type="text" class="form-control" placeholder="id de fin" aria-label="Recipient's username" name="idFin"/>
            </div>
        </div>
    </div>
    );
  }
}

ReactDOM.render(
  <Temporary />,
  document.getElementById('temporary')
);