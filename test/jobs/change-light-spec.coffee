{job} = require '../../jobs/change-light'

describe 'ChangeLight', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        updateLight: sinon.stub().yields null
      message =
        data:
          on: true
          lightNumber: 0
          color: 'white'
          transitionTime: 1000
          alert: 'alert-effect'
          effect: 'the-effect'
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call updateLight', ->
      data =
        lightNumber: 0
        on: true
        alert: 'alert-effect'
        color: 'white'
        effect: 'the-effect'
        transitionTime: 1000
      expect(@connector.updateLight).to.have.been.calledWith data

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
