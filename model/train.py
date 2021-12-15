import torch
import torch.functional as F
from tqdm import trange, tqdm


def train(model, device, train_loader, criterion, optimizer, batch_size, epoch, network_type):
    
    model.to(device)
    model.train()

    pbar = tqdm(range(epoch), colour = 'red')

    

    for epoch_idx in pbar:

        correct = 0
        processed = 0

        for trial_idx, (train_trial) in enumerate(train_loader):
            # get data loader for trial
            train_trial_loader = torch.utils.data.DataLoader(
                train_trial, batch_size=batch_size, shuffle=False, drop_last=False)

            

            for batch_idx, (data, target) in enumerate(train_trial_loader):

                data, target = data.to(device), target.to(device)

                # Init
                optimizer.zero_grad()
                # In PyTorch, we need to set the gradients to zero before starting to do backpropragation because PyTorch accumulates the gradients on subsequent backward passes.
                # Because of this, when you start your training loop, ideally you should zero out the gradients so that you do the parameter update correctly.

                # Predict

                y_pred = model(data).squeeze()

                # Calculate loss
                loss = criterion(y_pred, target)
                # PyTorch auto-differentiates the loss w.r.t. the parameters of the model for us, so we just need to call backward() to do the job.

                # Backpropagation
                loss.backward()

                optimizer.step()

                # Update pbar-tqdm
                pred = torch.nn.functional.softmax(y_pred, dim=1).argmax(
                    dim=1, keepdim=True)  # get the index of the max log-probability
                correct += pred.eq(target.view_as(pred)).sum().item()
                processed += len(data)
                accuracy = 100. * correct / processed

            pbar.set_description(
                desc=f'Loss={loss.item():0.2f} Epoch = {epoch_idx+1} Trial_idx={trial_idx} Accuracy={accuracy:0.2f}')


def evaluate(model, device, test_loader, criterion, batch_size):

    model.eval()
    test_loss = 0
    correct = 0
    batch_counter = 0
    with torch.no_grad():

        for trial_idx, (test_trial) in enumerate(test_loader):
            # get data loader for trial
            test_trial_loader = torch.utils.data.DataLoader(
                test_trial, batch_size=batch_size, shuffle=False, drop_last=False)

            
            for batch_idx, (data, target) in enumerate(test_trial_loader):

                data, target = data.to(device), target.to(device)
                output = model(data)
                # sum up batch loss
                test_loss += criterion(output, target).item()
                # get the index of the max log-probability
                pred = output.argmax(dim=1, keepdim=True)
                correct += pred.eq(target.view_as(pred)).sum().item()

                batch_counter += data.shape[0]

    test_loss /= batch_counter

    print('\nTest set: Average loss: {:.4f}, Accuracy: {}/{} ({:.2f}%)\n'.format(
        test_loss, correct, batch_counter,
        100. * correct / batch_counter))
