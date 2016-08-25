{job} = require '../../jobs/change-group'

describe 'ChangeGroup', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        changeGroup: sinon.stub().yields null
      message =
        data:
          on: true
          groupNumber: 0
          color: 'white'
          transitionTime: 1000
          alert: 'alert-effect'
          effect: 'the-effect'
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call changeGroup', ->
      data =
        groupNumber: 0
        on: true
        alert: 'alert-effect'
        color: 'white'
        effect: 'the-effect'
        transitionTime: 1000
      expect(@connector.changeGroup).to.have.been.calledWith data

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
