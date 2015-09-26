require_relative 'highbrow/neural/connection'
require_relative 'highbrow/neural/layer'
require_relative 'highbrow/neural/neuron'

require_relative 'highbrow/neural/activation/base'
require_relative 'highbrow/neural/activation/tanh'
require_relative 'highbrow/neural/activation/sigmoid'
require_relative 'highbrow/neural/activation/relu'
require_relative 'highbrow/neural/activation/softplus'

require_relative 'highbrow/neural/network/feed_forward'

require_relative 'highbrow/neural/trainer/base'
require_relative 'highbrow/neural/trainer/backpropagation'

require_relative 'highbrow/neural/trainer/plugin/base'
require_relative 'highbrow/neural/trainer/plugin/smart_learning_rate'
require_relative 'highbrow/neural/trainer/plugin/smart_momentum'
require_relative 'highbrow/neural/trainer/plugin/monitor'

require_relative 'highbrow/io/store'
require_relative 'highbrow/io/strategy/neural/network/feed_forward'
