HueManager = require '../src/hue-manager'

describe 'HueManager', ->
  beforeEach ->
    @sut = new HueManager

  describe '->createClient', ->
    beforeEach (done) ->
      @sut.createClient {}, done

    it 'should create a hue connection', ->
      expect(@sut.hue).to.exist

    it 'should update apikey', ->
      apikey =
        devicetype: 'newdeveloper'
      expect(@sut.apikey).to.deep.equal apikey

  context 'with an active client', ->
    beforeEach (done) ->
      @sut.createClient {}, (error) =>
        {@hue} = @sut
        done error

    describe '->changeLight', ->
      beforeEach (done) ->
        @hue.changeLights = sinon.stub().yields null
        data =
          lightNumber: 4
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeLight data, done

      it 'should call changeLights', ->
        options =
           lightNumber: 4
           on: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeLights).to.have.been.calledWith options

    describe '->changeGroup', ->
      beforeEach (done) ->
        @hue.changeLights = sinon.stub().yields null
        data =
          groupNumber: 9
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeGroup data, done

      it 'should call changeLights', ->
        options =
           lightNumber: 9
           on: true
           useGroup: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeLights).to.have.been.calledWith options
