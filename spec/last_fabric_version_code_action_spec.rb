describe Fastlane::Actions::LastFabricVersionCodeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The last_fabric_version_code plugin is working!")

      Fastlane::Actions::LastFabricVersionCodeAction.run(nil)
    end
  end
end
