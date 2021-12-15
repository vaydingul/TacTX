import torch
import torch.nn as nn
from tqdm import tqdm
from torch import autograd


class SysID_RNN(nn.Module):

    def __init__(self, input_size, hidden_size, output_size, num_layers, dropout=0.5):
        super(SysID_RNN, self).__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.output_size = output_size
        self.num_layers = num_layers

        self.rnn = nn.RNN(input_size, hidden_size, num_layers,
                          batch_first=True, dropout=dropout, nonlinearity='relu')
        # self.fc = nn.Sequential(
        #	nn.Linear(hidden_size, int(hidden_size/2)),
        #	nn.Linear(int(hidden_size/2), int(hidden_size/4)),
        #	nn.Linear(int(hidden_size/4), output_size)
        # )
        self.fc = nn.Linear(hidden_size, output_size)

    def forward(self, x):

        out, _ = self.rnn(x, self.init_hidden(x.size(0), x.device))
        out = self.fc(out[:, -1, :])

        return out

    def init_hidden(self, batch_size, device):

        self.hidden = torch.zeros(
            self.num_layers, batch_size, self.hidden_size).to(device)

    def generate_dummy_input_output(self, batch_size, seq_len):
        return torch.randn(batch_size, seq_len, self.input_size), torch.randn(batch_size, self.output_size)


class SysID_MLP(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, output_size, dropout=0.5):
        super(SysID_MLP, self).__init__()

        self.input_size = input_size
        self.output_size = output_size
        self.num_layers = num_layers
        self.hidden_size = hidden_size

        self.fc = nn.Sequential()
        self.fc.add_module('fc{}'.format(1), nn.Linear(self.input_size, self.hidden_size))
        self.fc.add_module('relu{}'.format(1), nn.ReLU())
        self.fc.add_module('dropout{}'.format(1), nn.Dropout(p=dropout))

        for k in range(2, self.num_layers):
            
            self.fc.add_module('fc{}'.format(k), nn.Linear(int(self.hidden_size / (2 ** (k-2))), int(self.hidden_size / (2 ** (k-1)))))
            self.fc.add_module('relu{}'.format(k), nn.ReLU())
            self.fc.add_module('dropout{}'.format(k), nn.Dropout(p=dropout))
        
        self.fc.add_module('fc{}'.format(self.num_layers), nn.Linear(int(self.hidden_size / (2 ** (self.num_layers-2))), self.output_size))

        #self.fc = nn.Sequential(
        #    nn.Linear(self.input_size, self.hidden_size),
        #    nn.ReLU(),
        #    nn.Dropout(p=dropout))
        #    
        #for k in range(2, self.num_layers):
#
        #    self.fc.add_module('fc{}'.format(k), nn.Linear(self.hidden_size, self.hidden_size))
        #    self.fc.add_module('relu{}'.format(k), nn.ReLU())
        #    self.fc.add_module('dropout{}'.format(k), nn.Dropout(p=dropout))
        #    
        #self.fc.add_module('fc{}'.format(num_layers), nn.Linear(self.hidden_size, self.output_size))
        

    def forward(self, x):
        out = self.fc(x)
        return out


def save_model(model, path):
    torch.save(model.state_dict(), path)

def load_model(model, path):
    model.load_state_dict(torch.load(path))

def save_optimizer(optimizer, path):
    torch.save(optimizer.state_dict(), path)

def load_optimizer(optimizer, path):
    optimizer.load_state_dict(torch.load(path))

def save_criterion(criterion, path):
    torch.save(criterion.state_dict(), path)

def load_criterion(criterion, path):
    criterion.load_state_dict(torch.load(path))


if __name__ == '__main__':

    input_size = 6
    hidden_size = 128
    output_size = 1
    num_layers = 3
    batch_size = 20
    seq_len = 3

    net = SysID(input_size, hidden_size, output_size, num_layers)
    net.train()

    criterion = nn.MSELoss()
    optimizer = torch.optim.Adam(net.parameters(), lr=0.001)
    pbar = tqdm(range(1000))

    for _ in pbar:

        x, y = net.generate_dummy_input_output(batch_size, seq_len)

        optimizer.zero_grad()
        output = net(x)
        loss = criterion(output, y)
        loss.backward()
        optimizer.step()

        pbar.set_description(f'Loss: {loss.item():.4f}')
